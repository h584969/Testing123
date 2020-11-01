const BildeViser = {
    /**
     * @type {Array<HTMLImageElement>}
     */
    bilder: [],

    init() {
        this.bilder.push(
            document.getElementById("bilde50"),
            document.getElementById("bilde150"),
            document.getElementById("bilde250"));

        for (let i = 0; i < this.bilder.length; i++) {
            this.bilder[i].setAttribute("style", "visibility:hidden");
        }
    },

    påklikk(hvilken) {
        for (let i = 0; i < this.bilder.length; i++) {

            if (hvilken === i) {

                this.bilder[i].setAttribute("style", "visibility:block");
            }
            else {
                this.bilder[i].setAttribute("style", "visibility:hidden");
            }
        }
    }

};


window.onload = () => {

    BildeViser.init();
};