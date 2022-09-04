float factorial(float f) {
    float result = 1;
    for (; f > 0.0f; f -= 1.0f) {
        result *= f;
    }
    return result;
}
