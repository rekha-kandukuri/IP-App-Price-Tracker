const express = require('express')
const bodyParser = require("body-parser");
const mongoose = require('mongoose')
require("dotenv").config();
// require('./db/mongoose')  
const { MongoClient, ObjectID } = require('mongodb')
const userRouter = require('./routers/user')
const taskRouter = require('./routers/task')
const PORT = process.env.PORT || 3000;

const app = express()

//connecting to database
const dbURI = "mongodb+srv://tanya:8447794252@cluster0-ef5hr.mongodb.net/ipprice?retryWrites=true&w=majority";
const databaseName = "ipprice";

mongoose
  .connect(dbURI, {
    useNewUrlParser: true,
    useCreateIndex: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Database Connected"))
  .catch((err) => console.log(err));

mongoose.Promise = global.Promise;

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());




// Allow CORS
// app.use((req, res, next) => {
//   res.header("Access-Control-Allow-Origin", "*");
//   res.header(
//     "Access-Control-Allow-Headers",
//     "Origin, X-Requested-With, Content-Type, Accept, Authorization"
//   );
//   if (req.method === "OPTIONS") {
//     res.header("Access-Control-Allow-Methods", "PUT, POST, PATCH, DELETE, GET");
//     return res.status(200).json({});
//   }
//   next();
// });



app.use(express.json())
app.use(userRouter)
app.use(taskRouter)





app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});