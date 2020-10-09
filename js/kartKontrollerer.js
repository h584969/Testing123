/*
 * Script som skal zoome og forflytte kartet ut ifra hva brukeren velger i navigasjonsmenyen
 * Et lite eksperiment (!^_^)
 */

const FYLKER = new Set([
    "Rogaland",
    "Agder",
    "MøreogRomsdal",
    "Trøndelag",
    "Nordland",
    "Vestland",
    "TromsogFinmark",
    "Innlandet",
    "Viken",
    "Oslo",
    "VestfoldogTelemark",
]);

const FYLKEPOSISJONER = {
    "Rogaland": {x: 568.817, y: 846.623},
    "Agder":{x: 609.951,y:868.351},
    "MøreogRomsdal":{x:609.694,y:655.673},
    "Trøndelag":{x:701.585,y:595.937},
    "Nordland":{x:764.338,y:338.793},
    "Vestland": {x: 565.676, y: 754.205},
    "TromsogFinmark":{x:931.194,y:222.902},
    "Innlandet":{x:685.390,y:735.265},
    "Viken":{x:676.084,y:798.384},
    "Oslo": {x: 713.635, y: 821.656},
    "VestfoldogTelemark":{x: 646.826, y: 830.080},
};

const FYLKESIRKLER = {};

const Zoomer = {
    /**
     * @type {SVGSVGElement}
     */
    kart: null,
    zoomAt(fylkeID){


        let punkt = FYLKEPOSISJONER[fylkeID];


        for (const t in FYLKESIRKLER){
            /**
             * @type {SVGCircleElement}
             */
            const c = FYLKESIRKLER[t];

            c.style.display ="none";
        }
        FYLKESIRKLER[fylkeID].style.display = "block";
       

        this.kart.currentTranslate.x = (this.kart.width.baseVal.value/2-punkt.x);
        this.kart.currentTranslate.y = (this.kart.height.baseVal.value/5-punkt.y);
        this.kart.currentScale = 2;
    },
    makeCircles(){
        for(const t in FYLKEPOSISJONER){
            let el = document.createElementNS("http://www.w3.org/2000/svg","circle");
            el.setAttributeNS(null,"cx",FYLKEPOSISJONER[t].x-5);
            el.setAttributeNS(null,"cy",FYLKEPOSISJONER[t].y-5);
            el.setAttributeNS(null,"r",5);
            el.setAttributeNS(null,"style","fill:none;stroke:white;stroke-width:2px;display:none;");
            el.setAttributeNS(null,"data-navn",t);
            FYLKESIRKLER[t] = el;
            Zoomer.kart.appendChild(el);
        } 
    }
};

window.onload = () =>{
    Zoomer.kart = document.getElementById("kart");
    Zoomer.makeCircles();
};

document.onkeydown = (ev) =>{
    if (ev.key.toLocaleLowerCase() === "a"){
        console.log(kart);
        Zoomer.kart.currentTranslate.x += 10;
    }
};
