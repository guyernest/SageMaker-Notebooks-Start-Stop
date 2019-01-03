import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

client = boto3.client('sagemaker')

def lambda_handler(event, context):
    
    candidates = client.list_notebook_instances(StatusEquals='InService')
    
    for candidate in candidates['NotebookInstances']:
        candidateName = candidate['NotebookInstanceName']
        logger.info('instance {0} is in Service'.format(candidateName))
        instanceArn = candidate['NotebookInstanceArn']
        instanceTags = client.list_tags(ResourceArn=instanceArn)
        for tag in instanceTags['Tags']:
            if (tag['Key'] == 'InDuty' and tag['Value'] =='Yes'):
                logger.info('instance {0} is in duty'.format(candidateName))
                if (event['event'] == "On"):
                    response = client.start_notebook_instance(NotebookInstanceName=candidateName)
                    logger.info('instance {0} was started'.format(candidateName))
                elif (event['event'] == "Off"):
                    response = client.stop_notebook_instance(NotebookInstanceName=candidateName)
                    logger.info('instance {0} was stopped'.format(candidateName))
            else:
                logger.info('Not in duty'.format(candidateName))

    return "Done"
