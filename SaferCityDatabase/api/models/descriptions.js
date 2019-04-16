const mongoose = require('mongoose');

const descriptionsSchema = mongoose.Schema({
    _id: mongoose.Schema.Types.ObjectId,
    name: String,
    zip: Number
});

module.exports = mongoose.model('Descriptions', descriptionsSchema);