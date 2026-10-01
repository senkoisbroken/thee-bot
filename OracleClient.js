class OracleClient {
    static key = null;
    static apiUrl = null;

    static setKey(k) {
        this.key = k;
    }

    static setApiUrl(u) {
        this.apiUrl = u;
    }

    static async decompile(bytecode) {
        return {
            ok: false,
            status: 503,
            statusText: "Oracle service offline / unconfigured",
            text: async () => "Oracle decompiler service is not configured."
        };
    }
}

module.exports = OracleClient;
