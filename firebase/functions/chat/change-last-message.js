const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp();

const db = admin.firestore();

exports.changeLastMessage = functions.firestore
	.document('rooms/{roomId}/messages/{messageId}')
	.onCreate((doc, context) => {
		functions.logger.log('Function started...');
		const message = doc.data();
		if (message) {
			message.id = doc.id;
			return db.doc('rooms/' + context.params.roomId).update({
				updatedAt: admin.firestore.FieldValue.serverTimestamp(),
				lastMessages: [message],
			});
		} else {
			functions.logger.log('Null returned');
			return null;
		}
	});
