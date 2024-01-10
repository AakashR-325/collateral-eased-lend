import logo from "./logo.svg";
import "./App.css";
import Navbar from "./Components/Navbar";
import MainPage from "./Components/MainPage";

function App() {
  return (
    <div
      className="App"
      style={{
        background: "linear-gradient(to right, #ad5389, #3c1053)",
      }}
    >
      <Navbar />
      <MainPage />
    </div>
  );
}

export default App;
