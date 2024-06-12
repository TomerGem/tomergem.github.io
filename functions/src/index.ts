import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as sgMail from "@sendgrid/mail";

admin.initializeApp();

const SENDGRID_API_KEY = functions.config().sendgrid.key;
sgMail.setApiKey(SENDGRID_API_KEY);

export const sendConfirmationEmail = functions.https.onCall(async (data) => {
  const {email} = data;

  const msg = {
    to: email,
    from: "info@enducloud.com",
    subject: "EnduCloud Waiting List Confirmation",
    text: `Congratulations! Email ${email} has been added to the waiting list.
We will notify you when you can register to EnduCloud.`,
  };

  try {
    await sgMail.send(msg);
    return {success: true};
  } catch (error) {
    const err = error as Error;
    console.error("Error sending email:", err);
    return {success: false, error: err.message};
  }
});
