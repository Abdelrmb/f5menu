document.addEventListener('DOMContentLoaded', function() {
    const menu = document.getElementById('menu');
    const menuContent = document.getElementById('menu-content');

    let menuStack = [];
    let keyLock = false;

    function showMenu(items, title) {
        menu.style.display = 'block';
        menuContent.innerHTML = ''; 

        const closeButton = document.createElement('div');

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Backspace' || event.key === 'Escape' ||event.key === 'F5') {
                if (!keyLock){
                    keyLock = true;
                    if (menuStack.length == 0) {
                    console.log('Delete key pressed for main menu menu length:' + menuStack.length);  
                    fetch(`https://${GetParentResourceName()}/menuAction`, {
                        method: 'POST',
                        body: JSON.stringify({ action: 'close' })
                    });
                    keyLock = false; 
                }
                else{
                    console.log('Delete key pressed for secondary menu menu length:' + menuStack.length); 
                    setTimeout(() => {
                            goBack();
                            keyLock = false; 
                        }, 100);
                }
            	console.log('LA TOUCHE POUR CLOSE A ETE PRESSEE')  ;
                }
            }
        });

        if (Array.isArray(items) && items.length > 0) {
            items.forEach(item => {
                const div = document.createElement('div');
                div.className = 'menu-item';

                const textContainer = document.createElement('span');
                textContainer.className = 'menu-text';
                textContainer.textContent = item.label;

                div.appendChild(textContainer);

                if (item.value) {
                    const arrowContainer = document.createElement('span');
                    arrowContainer.className = 'menu-arrow';
                    arrowContainer.textContent = ' >';
                    div.appendChild(arrowContainer);

                    div.dataset.value = item.value;
                    div.addEventListener('click', () => {
                        const value = div.dataset.value;
                        console.log('Item clicked:', value);
                        fetch(`https://${GetParentResourceName()}/menuAction`, {
                            method: 'POST',
                            body: JSON.stringify({ action: value })
                        }).then(response => response.json())
                          .then(data => console.log('Response from Lua:', data))
                          .catch(error => console.error('Error:', error));
                    });
                }

                menuContent.appendChild(div);
            });
        } else {
            console.error('Items is not defined, is not an array, or is empty.');
        }
    }

    function goBack() {
        if (menuStack.length > 0) {
            const previousMenu = menuStack.pop();
            showMenu(previousMenu.items, previousMenu.title);
        }
    }

    window.addEventListener('message', function(event) {
        if (event.data.action === 'showMenu') {
            menuStack = []; 
            showMenu(event.data.items, event.data.title);
        } else if (event.data.action === 'showSubMenu') {
            const currentMenuItems = [];
            document.querySelectorAll('.menu-item').forEach(item => {
                if (item.textContent !== 'Retour' && item.textContent !== 'Fermer') {
                    currentMenuItems.push({ label: item.querySelector('.menu-text').textContent, value: item.dataset.value });
                }
            });
            menuStack.push({
                items: currentMenuItems,
                title: document.querySelector('#menu-content').dataset.title || 'Menu'
            });
            showMenu(event.data.items, event.data.title);
        } else if (event.data.action === 'hideMenu') {
            menu.style.display = 'none';
        }
    });
});
