let DispatchDeletion = 0
let message = ''
let pocet = ''
let CurDispId = 0
let panic = false
let md = false
let gd = false
let locator = false
window.addEventListener('message', function(event) {
    const data = event.data;
    if(data.action == "GetConfig") {
       DispatchDeletion = data.DispatchDeletion
    }
    if(data.action == "button") {
       pressed(data.key)
    }
    if(data.action == "miles") {
       document.getElementById("distId").innerHTML = data.distMiles + data.type
       document.getElementById("timeId").innerHTML = data.time +"mins ago"
    }
    if(data.action == "GetCall") {
        message = data.message
        pocet = data.pocet
        CurDispId = data.CurDispId
        title = data.title
        panic = data.panic
        update()
    }
    if(data.action == "openSet") {
        this.document.getElementById('sett').style.display = "block"
    }
    if(data.action == "playPanic") {
        const sound = new Audio('panic.mp3');
            sound.play();
            sound.volume = 0.1
    }
});


function savechanges(){
    let cs = document.getElementById('callsign').value
    md = document.getElementById('muteDisp').checked
    gd = document.getElementById('getDisp').checked
    fetch(`https://md_dispatch/user`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            cs:cs, md:md
        })
    });

}
document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
       document.getElementById('sett').style.display = "none"
       fetch(`https://md_dispatch/closeMenu`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
            })
        });

    }
});

function update(){
    if (gd==false){
    document.getElementById("messageId").innerHTML = message
    document.getElementById("titleId").innerHTML = title
    document.getElementById("pocetId").innerHTML = pocet
    if (CurDispId==0){
        document.getElementById("container").style.display = "none"
    } else {
        document.getElementById("container").style.display = "block"
    }
    if (panic==true){
        const div = document.getElementById('top');
        let isRed = true;
        const interval = setInterval(() => {
            div.style.backgroundColor = isRed ? 'rgba(27, 69, 206, 1)':'rgb(158, 44, 44)';
            isRed = !isRed;
        }, 100);
        setTimeout(() => {
            clearInterval(interval);
            div.style.backgroundColor = "#2C2C2C";
            panic = false
        }, 2000);

    }
    }
    
}

function pressed(k){
    const element = document.getElementById(k);
    element.style.transition = 'background-color 0.1s, transform 0.1s';
    element.style.backgroundColor = '#2f2d31ff';
    element.style.border= "3px solid #4d4d4dff";
    element.style.transform = 'scale(1.005)';
    setTimeout(() => {
        element.style.backgroundColor = "#212023";
        element.style.border= "3px solid #2C2C2C";
        element.style.transform = 'scale(1)';
    }, 100);
}
