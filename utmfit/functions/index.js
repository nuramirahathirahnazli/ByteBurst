const functions = require('firebase-functions');
const stripe = require('stripe')('sk_test_51PRy8rF2XcU0Er0OTc3eG2pDpJTSwW27WXsynyKNAP6tWqiViSYQHraeg8RiJHuz4M4LiSsZSMmMhuY6xhSsOvDs008mv0WbsN');

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
    try {
        const { userId } = req.body;

        if (!userId) {
            return res.status(400).send({ success: false, error: 'Missing required parameter: userId' });
        }

        // Create a payment intent for RM5 (500 cents)
        const paymentIntent = await stripe.paymentIntents.create({
            amount: 500, // Amount in cents (RM5)
            currency: 'myr',
            metadata: { userId },
        });

        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            success: true,
        });
    } catch (error) {
        console.error('Error creating payment intent:', error);
        res.status(500).send({ success: false, error: error.message });
    }
});
