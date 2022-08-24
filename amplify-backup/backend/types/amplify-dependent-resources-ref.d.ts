export type AmplifyDependentResourcesAttributes = {
    "api": {
        "socale": {
            "GraphQLAPIKeyOutput": "string",
            "GraphQLAPIIdOutput": "string",
            "GraphQLAPIEndpointOutput": "string"
        }
    },
    "auth": {
        "SocaleAuth": {
            "IdentityPoolId": "string",
            "IdentityPoolName": "string",
            "HostedUIDomain": "string",
            "OAuthMetadata": "string",
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
    "analytics": {
        "socale": {
            "Region": "string",
            "Id": "string",
            "appName": "string"
        }
    },
    "function": {
        "S3Trigger3d9ab619": {
            "Name": "string",
            "Arn": "string",
            "Region": "string",
            "LambdaExecutionRole": "string"
        }
    },
    "storage": {
        "images": {
            "BucketName": "string",
            "Region": "string"
        }
    }
}