module.exports = function calculateTimeout(length) {
    if (typeof length !== 'number') return 10;
    return Math.min(Math.max(Math.floor(length / 2000), 5), 120);
};
