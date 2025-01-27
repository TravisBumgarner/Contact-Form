# Contact Form Server

A simple Express server that handles contact form submissions and sends notifications via Pushover.

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Copy `.env.example` to `.env` and fill in your Pushover credentials:
   ```bash
   cp .env.example .env
   ```
4. Start the development server:
   ```bash
   npm start
   ```

## Deployment to NearlyFreeSpeech

1. Build the TypeScript files:
   ```bash
   npm run build
   ```
2. Deploy to NearlyFreeSpeech:
   ```bash
   npm run deploy
   ```
   Note: Update the deploy script in package.json with your NearlyFreeSpeech username and server details.

## API Endpoint

POST `/contact`

Request body:
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "message": "Hello!",
  "website": "example.com"
}
``` 