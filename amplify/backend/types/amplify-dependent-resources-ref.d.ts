export type AmplifyDependentResourcesAttributes = {
    "auth": {
        "userPoolGroups": {
            "ucsdGroupRole": "string"
        },
        "socaleAuth": {
            "IdentityPoolId": "string",
            "IdentityPoolName": "string",
            "UserPoolId": "string",
            "UserPoolArn": "string",
            "UserPoolName": "string",
            "AppClientIDWeb": "string",
            "AppClientID": "string",
            "GoogleWebClient": "string",
            "FacebookWebClient": "string",
            "AppleWebClient": "string"
        }
    },
    "function": {
        "socaleAuthCustomMessage": {
            "Name": "string",
            "Arn": "string",
            "LambdaExecutionRole": "string",
            "Region": "string"
        }
    }
}