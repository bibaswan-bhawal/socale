const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "f04066c90f9441359e4c6fde5406dd72",
                    "region": "us-west-2"
                },
                "pinpointTargeting": {
                    "region": "us-west-2"
                }
            }
        }
    },
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "socale": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://gat56s2b3nd6xdi5hfvmvxj3cq.appsync-api.us-west-2.amazonaws.com/graphql",
                    "region": "us-west-2",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-juupjavcuzgqtb3smjdozbgnxu"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://gat56s2b3nd6xdi5hfvmvxj3cq.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-juupjavcuzgqtb3smjdozbgnxu",
                        "ClientDatabasePrefix": "socale_API_KEY"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-west-2:bbfb51d7-770f-46b8-8445-2578d2f1a84c",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_6Era7M8S5",
                        "AppClientId": "1oegp12a3ukgovv78dg45g9fq1",
                        "Region": "us-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "socalebc55fdf5-bc55fdf5-dev.auth.us-west-2.amazoncognito.com",
                            "AppClientId": "1oegp12a3ukgovv78dg45g9fq1",
                            "SignInRedirectURI": "socale://",
                            "SignOutRedirectURI": "socale://",
                            "Scopes": [
                                "phone",
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "f04066c90f9441359e4c6fde5406dd72",
                        "Region": "us-west-2"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "us-west-2"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "socale178ce0589f2d4ee9ba4f74026e48d99a105154-dev",
                        "Region": "us-west-2"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "socale178ce0589f2d4ee9ba4f74026e48d99a105154-dev",
                "region": "us-west-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';