import json

def lambda_handler(event, context):
    cars = [{"model": "accord", "make": "honda", "colour": "blue"}, {"model": "prius", "make": "toyota", "colour": "silver"}]
    return {
        'statusCode': 200,
        'body': json.dumps(cars)
    }