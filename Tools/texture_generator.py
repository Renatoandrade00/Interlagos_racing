import math
import struct
import zlib

def create_asphalt_png(filename="Graphics/asphalt_texture.png", width=512, height=512):
    # Gera uma textura de asfalto procedural granulada com pequenas variações de cinza e brita
    raw_data = bytearray()
    
    # Gerador pseudo-aleatório linear simples para repetibilidade
    seed = 123456789
    def pseudo_rand():
        nonlocal seed
        seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF
        return seed / 2147483647.0

    for y in range(height):
        raw_data.append(0) # PNG filter byte: None
        for x in range(width):
            # Ruído base para asfalto
            noise = pseudo_rand()
            grain = int((noise - 0.5) * 28.0)
            
            # Cor base de asfalto escuro (RGB ~ 45, 45, 48)
            r = max(20, min(80, 48 + grain))
            g = max(20, min(80, 48 + grain))
            b = max(20, min(85, 52 + grain))
            
            # Adicionar pequenas pedrinhas de brita esparsas
            if pseudo_rand() > 0.985:
                r += 30
                g += 30
                b += 30
            elif pseudo_rand() < 0.015:
                r -= 20
                g -= 20
                b -= 20

            raw_data.extend([r, g, b])

    save_png_rgb(filename, width, height, raw_data)

def create_grass_png(filename="Graphics/grass_texture.png", width=512, height=512):
    raw_data = bytearray()
    seed = 987654321
    def pseudo_rand():
        nonlocal seed
        seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF
        return seed / 2147483647.0

    for y in range(height):
        raw_data.append(0)
        for x in range(width):
            noise = pseudo_rand()
            grain = int((noise - 0.5) * 35.0)
            # Verde gramado com tons de terra
            r = max(25, min(90, 45 + grain))
            g = max(50, min(140, 95 + grain))
            b = max(15, min(65, 35 + int(grain * 0.5)))
            raw_data.extend([r, g, b])

    save_png_rgb(filename, width, height, raw_data)

def create_curb_png(filename="Graphics/curb_texture.png", width=256, height=256):
    raw_data = bytearray()
    for y in range(height):
        raw_data.append(0)
        # Faixas vermelhas e brancas diagonais
        for x in range(width):
            band = ((x + y) // 32) % 2
            if band == 0: # Vermelho vibrante de zebra
                r, g, b = 210, 25, 25
            else: # Branco zebra
                r, g, b = 235, 235, 240
            raw_data.extend([r, g, b])
            
    save_png_rgb(filename, width, height, raw_data)

def save_png_rgb(filename, width, height, raw_data):
    def png_chunk(chunk_type, data):
        c = chunk_type + data
        crc = zlib.crc32(c) & 0xffffffff
        return struct.pack(">I", len(data)) + c + struct.pack(">I", crc)

    compressed_data = zlib.compress(bytes(raw_data), 9)
    header = b"\x89PNG\r\n\x1a\n"
    ihdr = png_chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)) # 8-bit RGB
    idat = png_chunk(b"IDAT", compressed_data)
    iend = png_chunk(b"IEND", b"")

    with open(filename, "wb") as f:
        f.write(header + ihdr + idat + iend)
    print(f"Textura gerada com sucesso: {filename}")

if __name__ == "__main__":
    create_asphalt_png()
    create_grass_png()
    create_curb_png()
