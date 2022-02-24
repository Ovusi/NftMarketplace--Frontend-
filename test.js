// TEST SCRIPT


function Test(word) {
    console.log(word);
    const newWord = 'mad! this is what we do';
    console.log(newWord);

    this.new = function() {
        console.log("New method")
    }
}

Test('Vusi is legendury');
console.log(Test.newWord = 'twsit')

const items = [1, 2, 3];
for (let item in items) {
    console.log(item, items[item])
}

variable = new Test('vusiii');
variable.new()

function Number(num) { // test
    num1 = num
    num2 = "x"
    return num1 + num2
}

console.log(Number(23))

// const prompt = require("prompt-sync")({ sigint: true })
// const pro = prompt("input: ");
// alert('enter text: '+ pro);
// Ajax for sending http requests