const DBURL = '';

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
    ownerPhone: {type: string, required: true},
    ownerEmail: {type: string, required: true},
    ownerPet: [
      {type: mongoose.Schema.ObjectId, ref: 'Pet'}
    ]
  }
));

DB.model('Pet', new mongoose.Schema(
  {
    petName: {type: String, required: true},
    petType: {type: String, required: true}
  }
));

/**
 * Gets the pets owner
 * @param {mongoose.SchemaTypes.ObjectId} petId 
 * @returns {mongoose.Query}
 */
 function findOwners(petId) {
  return DB.model('Owner').find({ownerPet: petId});
}

/**
 * Gets a list of pets belonging to the specified owner
 * @param {mongoose.SchemaTypes.ObjectId} ownerId THe owners id
 * @returns {mongoose.Query}
 */
function findPets(ownerId) {
  return DB.model('Owner').findById(ownerId, 'ownerPet');
}

/**
 * Links a pet to their owner
 * @param {mongoose.SchemaTypes.ObjectId} petId The pet to link
 * @param {mongoose.SchemaTypes.ObjectId} OwnerId The owner to link
 * @returns {mongoose.Query}
 */
function linkToOwner(petId, OwnerId) {
  return DB.model('Owner').findByIdAndUpdate(OwnerId, {$addToSet: {ownerPet: petId}});
}

/**
 * Unlinks a pet from their owner
 * @param {mongoose.SchemaTypes.ObjectId} petId The pet to link
 * @param {mongoose.SchemaTypes.ObjectId} OwnerId The owner to link
 * @returns {mongoose.Query}
 */
function unlinkOwner(ownerId, petId) {
  return DB.model('Owner').findByIdAndUpdate(ownerId, {$pull: {ownerPet: petId}});
}
