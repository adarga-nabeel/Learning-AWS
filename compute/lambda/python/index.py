def lambda_handler(event, context):
   message = 'Hello {} !'.format(event['key1'])
   return {
       'message' : message
   }


def lambda_handler(event, context):
  username = event.get('key1', 'User')
  response_message = f"Hello {username}, all the best in your SAA exam!"
  return {
     'statusCode': 200,
     'body': response_message
  }