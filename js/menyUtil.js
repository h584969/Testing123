const menyUtil  ={
    /**
     * 
     * @param {HTMLLabelElement} button 
     */
    onDropdownMenuClick(button){
        button.parentElement.getElementsByClassName("underGruppe")[0].classList.toggle("vis");
    }
};