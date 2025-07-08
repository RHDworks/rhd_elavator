import { createTheme, type MantineColorsTuple } from "@mantine/core";

const rhd: MantineColorsTuple = [
    '#f8ffe2',
    '#f2ffcc',
    '#e6ff9a',
    '#d8ff64',
    '#cdff38',
    '#c5ff1d',
    '#bfff00',
    '#a9e300',
    '#95ca00',
    '#7eae00'
];

export const theme = createTheme({
    fontFamily: "Nexa-Book",
    colors: {
        dark:[
            "#C1C2C5",
            "#A6A7AB",
            "#909296",
            "#5c5f66",
            "#373A40",
            "#2C2E33",
            "#25262b",
            "#1A1B1E",
            "#141517",
            "#101113",
        ],
        rhd
    },
});