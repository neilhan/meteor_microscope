Template.meteorErrors.helpers({
    errors: () ->
        return Errors.collection.find()
})


Template.meteorError.rendered = () ->
    error = this.data
    Meteor.defer(()->
        Errors.collection.update(error._id, {$set: {seen: true}})
    )
