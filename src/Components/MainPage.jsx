import React, { useEffect } from "react";
import sphere from "../images/sphere.png";
import { Box, Button, Grid, Paper, Typography } from "@mui/material";
import "../styles/MainPage.css";

const MainPage = () => {
  return (
    <>
      <Grid
        container
        direction="row"
        columnSpacing={3}
        sx={{ ml: "2vw", mt: "10vh", mb: "20vh" }}
      >
        <Grid item sx={{ mt: "15vh", mr: "10vw", width: "50vw" }}>
          <Typography variant="h2" style={{ fontFamily: "sans-serif" }}>
            Leverage upto 500% on your collateral with the power of loan account
          </Typography>
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
      <Box
        sx={{
          backgroundColor: "#F9F6EE",
          minHeight: "50vh",
          width: "100vw",
          borderTopLeftRadius: "100px",
          borderTopRightRadius: "100px",
        }}
      >
        <Box
          sx={{
            pt: "20vh",
            pb: "10vh",
            fontSize: "80px",
            fontWeight: "600",
            fontFamily: "Quantico",
          }}
        >
          Pick Your Side
        </Box>
        <Grid container spacing={0}>
          <Grid
            item
            sx={{
              width: "30vw",
              ml: "auto",
              mt: "10vh",
              mb: "10vh",
            }}
          >
            <Paper
              elevation={5}
              sx={{
                backgroundColor: "#FAF9F6",
                height: "60vh",
                borderRight: "1px solid black",
                borderTopRightRadius: "0px",
                borderBottomRightRadius: "0px",
                borderTopLeftRadius: "10px",
                borderBottomLeftRadius: "10px",
              }}
            >
              <Typography variant="h4" sx={{ pt: "5vh", fontWeight: "500" }}>
                Passive Lending
              </Typography>
              <Typography
                sx={{
                  margin: "auto",
                  mt: "5vh",
                  width: "25vw",
                  fontSize: "20px",
                }}
              >
                For liquidity providers who want to passively invest in lending
                pools and get stable APY rewards. There is no need to actively
                manage any funds here. Supply liquidity in the LP and start
                earning passive APY!
              </Typography>
              <Button
                variant="contained"
                href="#contained-buttons"
                sx={{ mt: "6vh", minWidth: "15vw" }}
              >
                Lend and Earn
              </Button>
            </Paper>
          </Grid>
          <Grid
            item
            sx={{
              width: "30vw",
              mr: "auto",
              mt: "10vh",
              mb: "10vh",
            }}
          >
            <Paper
              elevation={5}
              sx={{
                backgroundColor: "#FAF9F6",
                height: "60vh",
                borderLeft: "1px solid black",
                borderTopRightRadius: "10px",
                borderBottomLeftRadius: "10px",
                borderTopLeftRadius: "0px",
                borderBottomLeftRadius: "0px",
              }}
            >
              <Typography variant="h4" sx={{ pt: "5vh", fontWeight: "500" }}>
                Active Borrowing
              </Typography>
              <Typography
                sx={{
                  margin: "auto",
                  mt: "5vh",
                  width: "25vw",
                  fontSize: "20px",
                }}
              >
                For the active traders who want to manage their risk, and
                leverage funds to trade them in different pool or swap tokens.
                Leverage upto 500% of your collateral with the power of the loan
                account!
              </Typography>
              <Button
                variant="contained"
                href="#contained-buttons"
                sx={{ mt: "6vh", minWidth: "15vw" }}
              >
                Borrow and Trade
              </Button>
            </Paper>
          </Grid>
        </Grid>
      </Box>
    </>
  );
};

export default MainPage;
