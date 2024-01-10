import React, { useEffect } from "react";
import sphere from "../images/sphere.png";
import { Grid } from "@mui/material";
import "../styles/MainPage.css";

const MainPage = () => {
  return (
    <>
      <Grid
        container
        direction="row"
        columnSpacing={12}
        sx={{ ml: "10vw", mt: "10vh" }}
      >
        <Grid item sx={{ mt: "100px", mr: "10vw", width: "30vw" }}>
          <h1 class="heading">Under-Collateralised</h1>
        </Grid>
        <Grid item>
          <img
            src={sphere}
            class="sphere"
            height="600px"
            border="solid 1px black"
          ></img>
        </Grid>
      </Grid>
    </>
  );
};

export default MainPage;
