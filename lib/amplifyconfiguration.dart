const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
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
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "c0756fd17b1f418cac0905a7acb10f31",
                    "region": "us-west-2"
                },
                "pinpointTargeting": {
                    "region": "us-west-2"
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
                    },
                    "socale_AWS_IAM": {
                        "ApiUrl": "https://gat56s2b3nd6xdi5hfvmvxj3cq.appsync-api.us-west-2.amazonaws.com/graphql",
                        "Region": "us-west-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "socale_AWS_IAM"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-west-2:65b88962-16cd-4270-9b83-d5778125994d",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_micwer9uL",
                        "AppClientId": "5t2fiunjbjgnke167piv0inra8",
                        "Region": "us-west-2"
                    }
                },
                "GoogleSignIn": {
                    "Permissions": "email,profile,openid",
                    "ClientId-WebApp": "1038363379354-438rslugb563casado20hbsumhp777l3.apps.googleusercontent.com"
                },
                "FacebookSignIn": {
                    "AppId": "413220534092388",
                    "Permissions": "public_profile"
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "socale98cab975-98cab975-dev.auth.us-west-2.amazoncognito.com",
                            "AppClientId": "5t2fiunjbjgnke167piv0inra8",
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
                        "socialProviders": [
                            "FACEBOOK",
                            "GOOGLE",
                            "APPLE"
                        ],
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
                        "AppId": "c0756fd17b1f418cac0905a7acb10f31",
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