Package.describe({
    summary: 'A pattern to display application errors to the user'
});


Package.on_use( function(api, where) {
    api.use(['coffeescript'], ['client', 'server']);
    api.use(['minimongo','mongo-livedata', 'templating'], 'client');
    api.add_files(['errors.coffee', 'errors_list.html', 'errors_list.coffee'], 'client');
    if(api.export)
        api.export('Errors', 'client');
});


Package.on_test(
        function(api) {
            api.use(['coffeescript', 'errors'], 'client');
            api.use(['tinytest', 'test-helpers'], 'client');

            api.add_files('errors_tests.coffee', 'client');
        }
)
