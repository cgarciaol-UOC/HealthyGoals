from backend.main import analyze_text

def test_analyze_text_loss_weight():
    input_text = "Quiero perder peso con una dieta vegetariana"
    result = analyze_text(input_text)
    assert result["objetive"] == "perder_peso"
    assert result["diet"] == "vegetariana"
