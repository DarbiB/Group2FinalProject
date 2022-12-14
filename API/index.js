const DBURL = 'mongodb+srv://admin:admin@cluster0.bhg4ucp.mongodb.net/testG2Final?retryWrites=true&w=majority';

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
  }, {collection: 'Billing'}
));

DB.model('Owner', new mongoose.Schema(
  {
    ownerFName: {type: String, required: true},
    ownerLName: {type: String, required: true},
    ownerAddress: {type: String, required: true},
    ownerCity: {type: String, required: true},
    ownerState: {type: String, required: true},
    ownerZip: {type: String, required: true},
    ownerPhone: {type: String, required: true},
    ownerEmail: {type: String, required: true},
    ownerPet: [
      {type: mongoose.Schema.ObjectId, ref: 'Pet'}
    ]
  }, {collection: 'Owner'}
));

DB.model('Pet', new mongoose.Schema(
  {
    petName: {type: String, required: true}
  }, {collection: 'Pet'}
));

let expressed = express();

expressed.use(express.json());
expressed.listen(1200);

expressed.get('/', (req, res) => {
  console.log('base get request: ' + req.url);
  console.log('base get data: ' + JSON.stringify(req.body));
  console.log('base get query: ' + JSON.stringify(req.query));
})

expressed.post('/editOwnerById', async (req, res) => {
  let {id: _id, ownerFName: ownerFirstName, ownerLName: ownerLastName, ownerAddress, ownerCity, ownerState, ownerZip, ownerPhone, ownerEmail} = req.body;

  let updateData = {};

  if (ownerFirstName) updateData.ownerFName = ownerFirstName;
  if (ownerLastName) updateData.ownerLName = ownerLastName;
  if (ownerAddress) updateData.ownerAddress = ownerAddress;
  if (ownerCity) updateData.ownerCity = ownerCity;
  if (ownerState) updateData.ownerState = ownerState;
  if (ownerZip) updateData.ownerZip = ownerZip;
  if (ownerEmail) updateData.ownerEmail = ownerEmail;
  if (ownerPhone) updateData.ownerPhone = ownerPhone;

  try {
    let result = await DB.model('Owner').findByIdAndUpdate(_id, updateData);

    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.get('/getAllInvoiceAndPet', async (req, res) => {
  try {
    let invoice = await DB.model('Billing').find().populate({path: 'ownerId', populate: {path: 'ownerPet'}});
    let body = [];
    for (i of invoice) {
      body.push({
        _id: i._id,
        ownerId: i.ownerId._id,
        hoursStayed: i.hoursStayed,
        hourRate: i.hourRate,
        amountOwed: i.amountOwed,
        petName: i.ownerId.ownerPet.length > 0 ? i.ownerId.ownerPet[0].petName: 'Unknown',
        fname: i.ownerId.ownerFName,
        lname: i.ownerId.ownerLName
      });
    }
    res.status(200).json({Billing: body});
  } catch {
    res.status(400).send();
  }
})

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

expressed.get('/getPetsOwners', async (req, res) => {
  try {
    let result = await DB.model('Owner').find({ownerPet: req.query.petId});
    res.status(200).json({Owners: result});
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
expressed.get('/getOwnersPets', async (req, res) => {
  try {
    let ownerId = req.query.id;
    let result = await DB.model('Owner').findById(ownerId, {ownerPet}).populate('ownerPet');
    res.status(200).json({Pets: result});
  } catch (err) {
    console.log(err);
    res.status(400).json(err);
  }
});

expressed.get('/ownersInvoices', async (req, res) => {
  try {
    let ownerId = req.body.id;
    let result = await DB.model('Billing').find({ownerId: ownerId});
    res.status(200).json({invoices: result});
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

expressed.get('/getOwner',  async (req,res) =>{
  try{
      let owner = await DB.model('Owner').findById(req.query.ownerId).populate('ownerPet');
      return res.status(200).json({"Owner" : owner});
  }
  catch{
      return res.status(500).json("(message: Failed to access owner data)");
  }
});


//Add owner
expressed.post('/addOwner', async (req,res) =>{
  try{
      let {ownerAddress, ownerCity, ownerEmail, ownerFName, ownerLName, ownerPhone, ownerState, ownerZip } = req.body;
      let result = await DB.model('Owner').create([{
          ownerAddress: ownerAddress,
          ownerCity: ownerCity,
          ownerEmail: ownerEmail,
          ownerFName: ownerFName,
          ownerLName: ownerLName,
          ownerPhone: ownerPhone,
          ownerState: ownerState,
          ownerZip: ownerZip

      }]);
      res.status(200).json(result);
      } catch(err){
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


//Get all pets
expressed.get('/getAllPets',  async (req,res) =>{
  try{
      let pet = await DB.model('Pet').find({}).lean();
      return res.status(200).json({"Pet" : pet});
  }
  catch{
      return res.status(500).json("(message: Failed to access pet data)");
  }
});


//Get all owners
expressed.get('/getAllOwners',  async (req,res) =>{
  try{
      let owner = await DB.model('Owner').find({}).lean();
      return res.status(200).json({"Owner" : owner});
  }
  catch{
      return res.status(500).json("(message: Failed to access owner data)");
  }
});


//Get all invoices
expressed.get('/getAllInvoices',  async (req,res) =>{
  try{
      let billing = await DB.model('Billing').find({}).lean();
      return res.status(200).json({"Billing" : billing});
  }
  catch{
      return res.status(500).json("(message: Failed to access billing data)");
  }
});

async function restoreDatabase() {
  let fs = require('fs');
  console.log('Restoring Billing');
  let data = JSON.parse(fs.readFileSync(__dirname + '/backups/billingData.json', {encoding: 'utf8'}));

  for (let i of data) {
    i.hourRate = 4;
  }
  console.log(data);
  await DB.model('Billing').deleteMany();
  await DB.model('Billing').create(data);

  console.log('Restoring Pets');
  await DB.model('Pet').deleteMany();
  await DB.model('Pet').create(JSON.parse(fs.readFileSync(__dirname + '/backups/petData.json', {encoding: 'utf8'})));

  console.log('Restoring Owners');
  await DB.model('Owner').deleteMany();
  await DB.model('Owner').create(JSON.parse(fs.readFileSync(__dirname + '/backups/ownerData.json', {encoding: 'utf8'})));

  console.log('Done Restoring');
}

process.stdin.on('data', (data) => {
  let commands = data.toString().split('\n');

  for (let c of commands) {
    switch (c.trim()) {
      case 'restore':
        restoreDatabase();
        break;
    }
  }
});
