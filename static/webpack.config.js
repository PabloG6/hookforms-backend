module.exports = {
    entry: "app.ts",
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'app.js',
    },

    module: {
        rules: [
            {
                test: 'tsx',
                use: 'ts-loader',
                exclude: '/node_modules/'
            }
        ]
    },
    resolve: {
        
    }
}