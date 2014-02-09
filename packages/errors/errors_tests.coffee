Tinytest.add('Errors collection works',
    (test) ->
        test.equal(Errors.collection.find({}).count(), 0)

        Errors.throw('A new error!')
        test.equal(Errors.collection.find({}).count(), 1)

        Errors.collection.remove({})
)

Tinytest.addAsync('Errors template works',
    (test, done) ->
        Errors.throw('A new error!')
        test.equal(Errors.collection.find({seen: false}).count(), 1)

        # render the template
        OnscreenDiv(Spark.render(
            () ->
                Template.meteorErrors()
        ))

        # wait a few milliseconds
        Meteor.setTimeout(
            () ->
                test.equal(Errors.collection.find({seen: false}).count(), 0)
                test.equal(Errors.collection.find({}).count(), 1)
                Errors.clearSeen()

                test.equal(Errors.collection.find({seen: true}).count(), 0)
                done()
            ,
            500
        )
)
