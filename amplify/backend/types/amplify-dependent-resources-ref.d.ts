export type AmplifyDependentResourcesAttributes = {
    "auth": {
        "userPoolGroups": {
            "UCSDGroupRole": "string",
            "UCLAGroupRole": "string",
            "UCBerkleyGroupRole": "string"
        },
        "socaleAuth": {
            "IdentityPoolId": "string",
            "IdentityPoolName": "string",
            "UserPoolId": "string",
            "UserPoolArn": "string",
            "UserPoolName": "string",
            "AppClientIDWeb": "string",
            "AppClientID": "string"
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