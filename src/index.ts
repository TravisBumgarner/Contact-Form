import axios from 'axios';
import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

type Submission = {
  email: string;
  name: string;
  message: string;
  timestamp: Date;
};

const prettyPrintSubmission = (submission: Submission) => {
  return `
    Name: ${submission.name}
    Email: ${submission.email}
    Message: ${submission.message}
    Timestamp: ${submission.timestamp}
  `;
};

app.post('/contact', async (req, res) => {
  try {
    const { email, name, message, website } = req.body;

    const submission: Submission = {
      email,
      name,
      message,
      timestamp: new Date()
    };

    // Send notification via Pushover
    const postData = {
      token: process.env.PUSHOVER_APP_TOKEN,
      user: process.env.PUSHOVER_USER_TOKEN,
      title: `Form Submission: ${website}`,
      message: prettyPrintSubmission(submission)
    };

    await axios.post('https://api.pushover.net/1/messages.json', postData, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    });

    res.status(200).json({
      status: 'success',
      message: 'Form submission successful'
    });
  } catch (error) {
    console.error('Error submitting form:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
}); 