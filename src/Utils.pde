static class Utils {

    static float roundToInterval(float val, float precision, int decimals) {
        int integer = round(val * pow(10, decimals));
        int intPrecision = round(precision * pow(10, decimals));

        int intResult = round(integer / intPrecision) * intPrecision;
        return (float) (intResult / Math.pow(10, decimals));
    }

    static int roundToInterval(int val, float precision) {
        int intResult = round((val / precision) * precision);
        return intResult;
    }

}