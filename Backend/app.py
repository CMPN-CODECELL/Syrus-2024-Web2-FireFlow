# # app.py
# from flask import Flask, request, jsonify
# import pickle
# import pandas as pd
# from flask_cors import CORS

# app = Flask(__name__)

# CORS(app)


# # Load the model
# with open('Backend/recommendation_fireflow.pkl', 'rb') as file:
#     cosine_sim = pickle.load(file)

# # Load the dataset
# df = pd.read_csv('Backend/locations_with_geocode_and_tags.csv')

# # print(os.getcwd())

# # Dictionary to store recommendations for each location
# recommendations_dict = {}

# @app.route('/get_recommendations', methods=['POST'])

# def get_recommendations():
#     data = request.get_json()
#     input_place = data.get('place')

#     # Check if the input place exists in the 'Place' column
#     if input_place in df['Place'].values:
#         # Find the index of the location in the dataset
#         location_index = df[df['Place'] == input_place].index[0]

#         # Get the cosine similarity scores for the location
#         sim_scores = list(enumerate(cosine_sim[location_index]))

#         # Sort the locations based on similarity scores
#         sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

#         # Get the top 11 similar locations
#         top_locations = [df['Location'].iloc[score[0]] for score in sim_scores[1:11]]

#     else:
#         # If the input place doesn't exist, recommend based on 'Tags', 'City', or 'Ratings'
#         relevant_columns = ['Tags', 'City', 'Ratings']
#         matching_locations = []

#         for column in relevant_columns:
#             # Get locations where the input matches the value in the specified column
#             matching_locations.extend(df[df[column] == input_place]['Location'].tolist())

#         # Remove duplicates
#         matching_locations = list(set(matching_locations))

#         # Limit the number of recommendations to 10
#         top_locations = matching_locations[:10]

#     return jsonify({'recommendations': top_locations})

# if __name__ == '__main__':
#     app.run()

# app.py
from flask import Flask, request, jsonify
import pickle
import pandas as pd
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Load the model
with open('Backend/recommendation_fireflow.pkl', 'rb') as file:
    loaded_cosine_sim = pickle.load(file)

# Load the dataset
# Make sure to have the correct file path for your dataset
df = pd.read_csv('Backend/locations_with_geocode_and_tags.csv')

# Dictionary to store recommendations for each location
recommendations_dict = {}

@app.route('/get_recommendations', methods=['POST'])
def get_recommendations():
    try:
        data = request.get_json()
        input_place = data.get('place')

        # Combine 'Place', 'City', and 'Ratings' into a single feature for recommendation
        df['Combined_Features'] = df['Place'] + ' ' + df['City'] + ' ' + df['Ratings'].astype(str)

        # Check if the input place exists in the 'Place' column
        if input_place in df['Place'].values:
            # Find the index of the location in the dataset
            location_index = df[df['Place'] == input_place].index[0]
            test_features = df['Combined_Features'].iloc[location_index]

            # Use cosine similarity on the combined features
            sim_scores = list(enumerate(loaded_cosine_sim[location_index]))

            # Similarity basis pe sorting
            sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

            # Get the top 11 similar locations
            top_locations = [df['Place'].iloc[score[0]] for score in sim_scores[1:12]]

        else:
            # If the input place doesn't exist, recommend based on 'Tags', 'City', or 'Ratings'
            relevant_columns = ['Tags', 'City', 'Ratings']
            matching_locations = ['NOT Found']

            for column in relevant_columns:
                # Get locations where the input matches the value in the specified column
                matching_locations.extend(df[df[column] == input_place]['Place'].tolist())

            # Remove duplicates
            matching_locations = list(set(matching_locations))

            # Limit the number of recommendations to 10
            top_locations = matching_locations[:10]

        return jsonify({'recommendations': top_locations})

    except Exception as e:
        return jsonify({'error': str(e)}), 500  # Return the error message and a 500 status code

if __name__ == '__main__':
    app.run(debug=True)
