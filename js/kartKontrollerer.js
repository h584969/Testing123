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

const Zoomer = {
    /**
     * @type {SVGSVGElement}
     */
    kart: null,
    zoomAt(fylkeID){
        if (!this.kart) this.kart = document.getElementById("kart");
        /**
         * @type {SVGPathElement}
         */
        let fylke = this.kart.getElementsByClassName(fylkeID)[0];
        let lengde = fylke.getTotalLength();
        let punkt = {
            x: 0,
            y: 0,
        };
        for (var i = 0; i < lengde; i++){ //TODO finne en måte å få tak i alle punktene uten å måtte gå rundt
            let p = fylke.getPointAtLength(i);
            punkt.x += p.x;
            punkt.y += p.y;
        }
        i--;
        punkt.x /= i;
        punkt.y /= i;

        this.kart.currentTranslate.x = this.kart.clientWidth/2 -punkt.x;
        this.kart.currentTranslate.y = this.kart.clientHeight/2 -punkt.y*2;

        this.kart.currentScale = 2;

    }
};