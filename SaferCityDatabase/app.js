const express = require('express');
const app = express();

const descriptionRoutes = require('./api/routes/description');
const mongoose = require('mongoose');
app.use('/description', descriptionRoutes);

mongoose.connect('mongodb+srv://Safer-City:' + process.env.MONGO_ATLAS_PW + '@safer-city-oceuv.mongodb.net/test?retryWrites=true',
{
    useMongoClient: true
});
module.exports = app;