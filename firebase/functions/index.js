const functions = require('firebase-functions');
const changeLastMessage =
	require('./chat/change-last-message').changeLastMessage;

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.changeLastMessage = changeLastMessage;
