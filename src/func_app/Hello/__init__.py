import json
import logging

import azure.functions as func


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger processed a request.')
    payload = {"message": "MCP Hello, world!"}
    return func.HttpResponse(json.dumps(payload), mimetype="application/json", status_code=200)
