#!/usr/bin/env python3

from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/process_video', methods=['POST'])
def process_video():
    # Get input and output filenames from the request
    data = request.get_json()
    input_filename = data.get('input_filename')
    output_filename = data.get('output_filename')

    # Check if both input and output filenames are provided
    if not input_filename or not output_filename:
        return jsonify({'error': 'Both input and output filenames are required.'}), 400

    try:
        # Run the process_video command
        subprocess.run(['run_video_inferer', input_filename, '-o', output_filename], check=True)
    except subprocess.CalledProcessError as e:
        return jsonify({'error': f'Command failed with error: {e.output.decode()}'}), 500

    # Return the output filename
    return jsonify({'output_filename': output_filename})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
