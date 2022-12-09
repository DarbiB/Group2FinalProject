const DBURL = 'mongodb://localhost:27017/testG2Final';

const mongoose = require('mongoose');
const express = require('express');

mongoose.connect(DBURL, {useNewUrlParser: true, useUnifiedTopology: true});

const DB = mongoose.connection;

DB.model('Billing', new mongoose.Schema(
  {
    ownerId: {type: mongoose.SchemaTypes.ObjectId, required: true, ref: 'Owner'},
    hoursStayed: {type: Number, required: true, default: 0},
    hourRate: {type: Number, required: true, default: 20},
    amountOwed: {type: Number, required: true, default: 0}
  }
));

DB.model('Owner', new mongoose.Schema(
  {
    ownerFirstName: {type: String, required: true},
    ownerLastName: {type: String, required: true},
    ownerAddress: {type: String, required: true},
    ownerCity: {type: String, required: true},
    ownerState: {type: String, required: true},
    ownerZip: {type: String, required: true},
    ownerPhone: {type: String, required: true},
    ownerEmail: {type: String, required: true},
    ownerPet: [
      {type: mongoose.Schema.ObjectId, ref: 'Pet'}
    ]
  }
));

DB.model('Pet', new mongoose.Schema(
  {
    petName: {type: String, required: true}
  }
));

let expressed = express();

expressed.use(express.json());
expressed.listen(1200);

expressed.post('/editOwnerById', async (req, res) => {
  let {ownerId: _id, ownerFirstName, ownerLastName, ownerAddress, ownerCity, ownerState, ownerZip, ownerPhone, ownerEmail} = req.body;

  let updateData = {};

  if (ownerFirstName) updateData.ownerFirstName = ownerFirstName;
  if (ownerLastName) updateData.ownerLastName = ownerLastName;
  if (ownerAddress) updateData.ownerAddress = ownerAddress;
  if (ownerCity) updateData.ownerCity = ownerCity;
  if (ownerState) updateData.ownerState = ownerState;
  if (ownerZip) updateData.ownerZip = ownerZip;
  if (ownerEmail) updateData.ownerEmail = ownerEmail;
  if (ownerPhone) updateData.ownerPhone = ownerPhone;

  try {
    let result = await DB.model('Owner').findByIdAndUpdate(ownerId, updateData);

    res.status(200).json(result);
  } catch (err) {
    res.status(400).json(err);
  }
});

// creating a pet with the option of linking them to an owner
expressed.post('/addPet', async (req, res) => {
  let {_id, petName, ownerId} = req.body;
  let data = {petName: petName};
  if (_id) data._id = _id;

  try {
    // adding the pet
    let result = await (DB.model('Pet').create([data])), resBody = 'Created: ' + JSON.stringify(result);

    // if an owner was provided add the owner to the pet
    if (ownerId && result.length === 1) {
      try {
          await DB.model('Owner').findByIdAndUpdate(ownerId, {$addToSet: {ownerPet: petId}});
          resBody += ', linked to ' + ownerId;
      } catch (err) {
        console.log(err);
        resBody += ', failed to link to ' + ownerId;
      }
    }

    res.status(200).send(resBody);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

// linking the pet to an owner
expressed.post('/linkOwner', async (req, res) => {
  let {petId, ownerId} = req.body;
  try {
    let result = await DB.model('Owner').findByIdAndUpdate(ownerId, {$addToSet: {ownerPet: petId}});

    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.post('/deletePet', async (req, res) => {
  try {
    let petId = req.body.petId;
    // removing the pet from all owners
    await DB.model('Owner').updateMany({ownerPet: petId}, {$pull: {ownerPet: petId}});

    // removing the pet
    await DB.model('Pet').findByIdAndRemove(petId);
    res.status(200).send('successfully removed pet');
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.post('/unlinkOwner', async (req, res) => {
  try {
    let {petId, ownerId} = req.body;
    let result = await DB.model('Owner').updateOne({ownerId: ownerId}, {$pull: {ownerPet: petId}});
    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
})

// gets all the pets for the given owner
expressed.get('/ownersPets', async (req, res) => {
  try {
    let ownerId = req.body.id;
    let result = await DB.model('Owner').findById(ownerId, {ownerPet}).populate('ownerPet');
    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.get('/ownersInvoices', async (req, res) => {
  try {
    let ownerId = req.body.id;
    let result = await DB.model('Billing').find({ownerId: ownerId});
    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.post('/addInvoice', async (req, res) => {
  try {
    let {ownerId, hoursStayed, hourRate, amountOwed} = req.body;
    let result = await DB.model('Billing').create([{
      ownerId: ownerId,
      hoursStayed: hoursStayed,
      hourRate: hourRate,
      amountOwed: amountOwed
    }]);

    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.post('/editInvoice', async (req, res) => {
  try {
    let {id, ownerId, hoursStayed, hourRate, amountOwed} = req.body,
        updateData = {};

    if (ownerId) updateData.ownerId = ownerId;
    if (hoursStayed) updateData.hoursStayed = hoursStayed;
    if (hourRate) updateData.hourRate = hourRate;
    if (amountOwed) updateData.amountOwed = amountOwed;

    let result = await DB.model('Billing').findByIdAndUpdate(id, updateData);
    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.post('/deleteInvoice', async (req, res) => {
  try {
    let {id} = req.body;
    await DB.model('Billing').remove({_id: id});
    res.status(200).send('Deleted Invoice successfully');
  } catch (err) {
    res.status(400).json(err);
  }
});


//Add owner
expressed.post('/addOwner', async (req,res) =>{
  try{
      let {firstName, lastName, ownerAddress, ownerPhone, ownerEmail} = req.body;
      let result = await DB.model('Owner').create([{
          lastName: lastName,
          firstName: firstName,
          ownerAddress: ownerAddress,
          ownerPhone: ownerPhone,
          ownerEmail: ownerEmail,

      }]);
      res.status(200).json(result);
      } catch(err){
        console.log(err);
      res.status(400).json(err);      
      }
    });

  
//Edit Pet Name by ID
expressed.post('/editPetNameById', async (req,res)=>{
  try{
      let pet = await DB.model('Pet').updateOne({_id: req.body.id}
          ,{
              petName: req.body.petName
          },{upsert: true});
          
      if(pet)
      {
          res.status(200).json("{message: Pet Name Edited}");       
      }
      else{
          res.status(200).json("{message: No Name Changed}");
      }
  }
  catch{
      return res.status(500).json("{message: Failed to edit name}");
  }

});


  

