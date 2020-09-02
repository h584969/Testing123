const menyUtil  ={
    /**
     * 
     * @param {HTMLButtonElement} button 
     */
    onDropdownMenuClick(button){
        button.parentElement.getElementsByClassName("dropdown-content")[0].classList.toggle("show");
    }
};