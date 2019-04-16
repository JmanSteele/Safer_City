const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");

router.get("/", (req, res, next) => {
    Product.find()
      .exec()
      .then(docs => {
        console.log(docs);
        //   if (docs.length >= 0) {
        res.status(200).json(docs);
        //   } else {
        //       res.status(404).json({
        //           message: 'No entries found'
        //       });
        //   }
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({
          error: err
        });
      });
  });

const Descriptions = require("../models/descriptions");

 router.post("/", (req, res, next) => {
        const descriptions = new Descriptions({
          _id: new mongoose.Types.ObjectId(),
          name: req.body.name,
          zip: req.body.zip
        });
        product
        .save()
        .then(result => {
            console.log(result);
    res.status(200).json({
        message: 'Handling POST requests to /description'
    });
})
.catch(err => {
    console.log(err);
    res.status(500).json({ error: err });
});
});

router.get("/:descriptionsId", (req, res, next) => {
    const id = req.params.descriptionsId;
    Product.findById(id)
      .exec()
      .then(doc => {
        console.log("From database", doc);
        if (doc) {
          res.status(200).json(doc);
        } else {
          res
            .status(404)
            .json({ message: "No valid entry found for provided ID" });
        }
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({ error: err });
      });
  });
  
  router.patch("/:descriptionsId", (req, res, next) => {
    const id = req.params.descriptionId;
    const updateOps = {};
    for (const ops of req.body) {
      updateOps[ops.propName] = ops.value;
    }
    Product.update({ _id: id }, { $set: updateOps })
      .exec()
      .then(result => {
        console.log(result);
        res.status(200).json(result);
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({
          error: err
        });
      });
  });
  
  router.delete("/:descriptionsId", (req, res, next) => {
    const id = req.params.descriptionsId;
    Product.remove({ _id: id })
      .exec()
      .then(result => {
        res.status(200).json(result);
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({
          error: err
        });
      });
  });
module.exports = router;