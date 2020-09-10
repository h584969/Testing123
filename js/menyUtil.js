const menyUtil  ={
    /**
     * 
     * @param {HTMLLabelElement} button 
     */
    onDropdownMenuClick(button){
        button.parentElement.getElementsByClassName("underGruppe")[0].classList.toggle("vis");
        if (FYLKER.has(button.innerText.replace(/\s/g,""))){
            Zoomer.zoomAt(button.innerText.replace(/\s/g,""));
        }
    }

    
};