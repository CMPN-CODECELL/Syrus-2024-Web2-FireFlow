# app.py
from flask import Flask, request, jsonify
import pickle
import pandas as pd
from flask_cors import CORS

app = Flask(__name__)

CORS(app)

# Load the model
with open('pkl file path', 'rb') as file:
    cosine_sim = pickle.load(file)

# Load the dataset
df = pd.read_csv('dataset.csv file')

# Dictionary to store recommendations for each location
recommendations_dict = {}

@app.route('/get_recommendations', methods=['POST'])

def get_recommendations():
    data = request.get_json()
    location = data.get('location')

    # Find the index of the location in the dataset
    location_index = df[df['Location'] == location].index[0]

    # Get the cosine similarity scores for the location
    sim_scores = list(enumerate(cosine_sim[location_index]))

    # Sort the locations based on similarity scores
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

    # Get the top 11 similar locations
    top_locations = [df['Location'].iloc[score[0]] for score in sim_scores[1:11]]

    return jsonify({'recommendations': top_locations})

    # # Append the new recommendations to the existing list for the location
    # if location in recommendations_dict:
    #     recommendations_dict[location].extend(top_locations)
    # else:
    #     recommendations_dict[location] = top_locations

    # # Return JSON response with the recommendations
    # return jsonify({'recommendations': recommendations_dict[location]})

if __name__ == '__main__':
    app.run()