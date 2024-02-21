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
import google.generativeai as genai
from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from math import radians, sin, cos, sqrt, atan2


app = Flask(__name__)
CORS(app)
api_key = os.getenv('GOOGLE_GENAI_API_KEY')
genai.configure(api_key=api_key)
# import google.generativeai as genai
# import streamlit as st
# import PIL.Image

# # # Load the model
# # with open('Backend/recommendation_fireflow.pkl', 'rb') as file:
# #     loaded_cosine_sim = pickle.load(file)

# # # Load the dataset
# # # Make sure to have the correct file path for your dataset
df = pd.read_csv('Backend/locations_with_geocode_and_tags.csv')

# # # Dictionary to store recommendations for each location
# # recommendations_dict = {}

# Load the CSV file into a DataFrame
df1 = pd.read_csv('Backend/restaurant_data.csv')

# Function to calculate distance between two coordinates using Haversine formula
def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0  # Earth radius in kilometers

    # Convert latitude and longitude from degrees to radians
    lat1_rad = radians(lat1)
    lon1_rad = radians(lon1)
    lat2_rad = radians(lat2)
    lon2_rad = radians(lon2)

    # Calculate the change in coordinates
    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad

    # Calculate the Haversine formula
    a = sin(dlat / 2)**2 + cos(lat1_rad) * cos(lat2_rad) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    distance = R * c

    return distance

# Function to suggest restaurants based on location and type of food
def suggest_restaurants(lat, lon, cuisine, num_restaurants=3):
    df1['distance'] = df1.apply(lambda row: haversine(lat, lon, float(row['location_latitude']), float(row['location_longitude'])), axis=1)
    filtered_df = df1[(df1['cuisine'].str.contains(cuisine, case=False))]
    sorted_df = filtered_df.sort_values(by='distance')
    suggested_restaurants = sorted_df.head(min(num_restaurants, len(sorted_df)))
    return suggested_restaurants[['name', 'cuisine', 'aggregate_rating', 'cost_for_two', 'distance']]

@app.route('/suggest_restaurants', methods=['POST'])
def suggest_restaurants_api():
    try:
        data = request.get_json()
        lat = data.get('lat')
        lon = data.get('lon')
        cuisine = data.get('cuisine')
        num_suggestions = data.get('num', 3)
        
        suggestions = suggest_restaurants(lat, lon, cuisine, num_suggestions)
        
        return jsonify({'restaurants': suggestions.to_dict(orient='records')})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/get_recommendations', methods=['POST'])
def get_recommendations():
    try:
        data = request.get_json()
        input_place = data.get('place')

        # Combine 'Place', 'City', and 'Ratings' into a single feature for recommendation
        df['Combined_Features'] = df['Place'] + ' ' + df['City'] + ' ' + df['Ratings'].astype(str)

#         # Check if the input place exists in the 'Place' column
        if input_place in df['Place'].values:
            # Find the index of the location in the dataset
#             location_index = df[df['Place'] == input_place].index[0]
            test_features = df['Combined_Features'].iloc[location_index]

#             # Use cosine similarity on the combined features
        #     sim_scores = list(enumerate(loaded_cosine_sim[location_index]))

#             # Similarity basis pe sorting
#             sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

#             # Get the top 11 similar locations
#             top_locations = [df['Place'].iloc[score[0]] for score in sim_scores[1:12]]

        else:
            # If the input place doesn't exist, recommend based on 'Tags', 'City', or 'Ratings'
            relevant_columns = ['Tags', 'City', 'Ratings']
            matching_locations = ['NO Match Found']

            for column in relevant_columns:
                # Get locations where the input matches the value in the specified column
                matching_locations.extend(df[df[column] == input_place]['Place'].tolist())

            # Remove duplicates
            matching_locations = list(set(matching_locations))

            # Limit the number of recommendations to 10
            top_locations = matching_locations[:10]

#         return jsonify({'recommendations': top_locations})

    except Exception as e:
        return jsonify({'error': str(e)}), 500  # Return the error message and a 500 status code
#     # # Append the new recommendations to the existing list for the location
#     # if location in recommendations_dict:
#     #     recommendations_dict[location].extend(top_locations)
#     # else:
#     #     recommendations_dict[location] = top_locations

#     # # Return JSON response with the recommendations
#     # return jsonify({'recommendations': recommendations_dict[location]})

if __name__ == '__main__':
    app.run(debug=True)
