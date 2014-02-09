# collection of the errors

@Errors = {
    # Local client-only collection
    collection: new Meteor.Collection(null)

    # function for call-backs to put messages in Errors
    throw: (message) ->
        Errors.collection.insert({message: message, seen: false})

    clearSeen: () ->
        Errors.collection.remove({seen: true})
}

Errors = @Errors
