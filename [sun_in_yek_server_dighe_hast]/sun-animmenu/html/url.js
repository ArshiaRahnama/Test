function en(url) {
    return btoa(url)
}

function de(url) {
    return atob(url)
}

function getUrl(category, name) {
    let url = `https://cdn.sunrp.ir/img/animmenu/gif/${name}.webp`;
    return en(url)
}

function getUrlImg(category, name) {
    let url = `https://cdn.sunrp.ir/img/animmenu/img/${name}.webp`;
    return en(url)
}