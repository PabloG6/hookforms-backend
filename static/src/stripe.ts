import {Stripe} from 'stripe';
import {loadStripe} from '@stripe/stripe-js';
const config: Stripe.StripeConfig = {apiVersion: '2020-08-27'}
loadStripe("pk_test_eIUYFI75sarVNv3w37C7fARu00aIomt23f").then((stripe) => {
    const elements = stripe.elements();

    const card = elements.create("card", {style: {}});
    card.mount("#card-elements");
    
    
});

