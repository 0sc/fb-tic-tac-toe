# Tic-Tac-Toe Messenger Bot

This is an adaptation of the classic [Tic-Tac-Toe](https://en.wikipedia.org/wiki/Tic-tac-toe) game for the Facebook Messenger platform. This adaptation allows a user enjoy the game playing against an AI bot on the messenger platform.

The core logic of the game is provided from [Mechanicles CLI implementation](https://github.com/mechanicles/ruby-tictactoe).


## Dependencies
### System
**Tic-Tac-Toe Messenger Bot** is built with the Ruby programming language (version 2.4.1). Chances are you already have Ruby. You can run `which ruby` to confirm it's installation.

*   if Ruby is not installed checkout the [ruby installation guide](https://www.ruby-lang.org/en/downloads/) for guidelines to setup Ruby on your machine

Also check for and confirm the [installation of gem](http://guides.rubygems.org/rubygems-basics/) and [bundler](http://rubygems.org) on your machine. These will allow you install other libraries ( _gems_ ) required.

### Facebook
A fair understanding of the mechanics of the Bot for Messenger platform is required. You'll need a Facebook App, a Facebook Page.

### Cloudinary
Images of the state of the game board after each turn is generated and saved to Cloudinary from where it's delivered to Facebook. For this app, you'll need a [cloudinary account](https://cloudinary.com/users/register/free).

### Database setup
This implementation leverages a postgres db to persist state and game sessions for users. The database maintains a single table `games` which keeps track of the gameplay for each user. Yes, you can user any other db of your choice; all you need do is swap out `pg` [here](game/db.rb) for your choice db.

### Configuration
You'll need to set the following env variables need by the app:

```bash
VERIFY_TOKEN # Your Messenger Webhook verification token
ACCESS_TOKEN # Your Access token for you Facebook page
CLOUDINARY_CLOUD_NAME # Your cloudinary account name
CLOUDINARY_API_KEY # Your cloudinary account api key
CLOUDINARY_API_SECRET # Your cloudinary account api secret
DATABASE_URL # Your database url
```

## Running the application
First [clone this repo](clone). Then from your terminal (or command prompt) navigate to the folder where you have cloned *fb-tic-tac-toe* ( __cd path/to/fb-tic-tac-toe/__ ).

*   Run __bundle install__ to install all *Plans* dependencies.
*   Run __rake db:setup__ to setup the database
*   Run __rackup__ to start the app

You are now good to go. Proceed with webhook verification and then test out the game on your Facebook page.


> Note: you might need to setup ngrok to tunnel requests if you are running it locally.

I added in a [`start.sh`](start.sh) file which you can modify to make startup easier especially regarding exporting the required env variables. You can you use it like so:
* Update [`start.sh`](start.sh) with your env variables and start up command

```bash
export VERIFY_TOKEN=[YOUR FB WEBHOOK VERFIFICATION TOKEN]
export ACCESS_TOKEN=[YOUR FB PAGE ACCESS TOKEN]
export CLOUDINARY_CLOUD_NAME=[YOUR COULDINARY ACCOUNT NAME]
export CLOUDINARY_API_KEY=[YOUR CLOUDINARY API KEY]
export CLOUDINARY_API_SECRET=[YOUR CLOUDINARY API SECRET]
export DATABASE_URL=[YOUR DATABASE CONNECTION URL]

rake db:setup
rackup
```

* make the script executable

```bash
> chmod +x start.sh
```

3. execute the script

```bash
> ./start.sh
```

# Todo
This implementation can benefit from a lot of very easy to add upgrades such as:

* users having multiple game sessions
* users playing against their friends
* users undoing their move
* overall bot UX improvements

... etc

Feel free to take a crack at any of them, I'll love to see what you come up with.
