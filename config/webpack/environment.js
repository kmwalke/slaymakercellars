const { environment } = require('@rails/webpacker')

const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery' // or if its not work specify path `'jquery/src/jquery'` which node_modules path for jquery
    }));

module.exports = environment
