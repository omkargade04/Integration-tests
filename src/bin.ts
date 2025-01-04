import { app } from "./index";

app.listen((3000), () => {
    console.log(process.env.DATABASE_URL)
});