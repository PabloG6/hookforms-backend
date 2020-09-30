import {MDCRipple} from '@material/ripple/index';
import {Socket} from "phoenix";
import "./styles.scss";
import {LiveSocket} from "phoenix_live_view"
import './src/stripe';
let liveSocket = new LiveSocket("/live", Socket, {})
liveSocket.connect()

const ripple = new MDCRipple(document.querySelector('.primary-button'));
