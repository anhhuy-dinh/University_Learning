import numpy as np
import soundfile as sf
import matplotlib.pyplot as plt

def main():
    # read sound file "sound_wav"
    path = 'sound.wav'
    data, samplerate = sf.read(path)
    # print shape of data
    print(data.shape)
    '''
        Shape of data: (1411200, 2)
        where:
            1411200: number of samples of the speech signals
            2: number of channels. The two columns are the left and right channels.
    '''
    # Create a new wav file where samples is data*200 and samplerate likes sound.wav
    sf.write('new_file1.wav', data*200, samplerate)
    # Create a new wav file "stereo_file.wav" where matrix of samples has shape (200000, 2) with random values, samplerate is 44100 and subtype is PCM_24
    sf.write('stereo_file.wav', np.random.randn(200000, 2), 44100, 'PCM_24')
    # Show plot of samples of each channel
    fig, ax = plt.subplots(nrows=1, ncols=2)
    ax[0].plot(data[:,0])
    ax[1].plot(data[:,1])
    plt.show()
    # Create a new wav file "new_split_file.wav" where number of samples is a half of samples of sound.wav
    data2 = np.empty((data.shape[0]//2, 2))
    data2 = data[data.shape[0]//2:, :]
    sf.write('new_split_file.wav', data2, samplerate)
    # Reverse sound.wav
    sound = data[::-1, :]
    sf.write('channel1.wav', sound, samplerate)
    # Set one channel is 0
    sound1 = data
    sound1[:, 1] = 0
    sf.write('channel2.wav', sound1, samplerate)
    # Set both 2 channels is 0
    sound1[:, 0] = 0
    sound1[:, 1] = 0
    sf.write('all.wav', sound1, samplerate)

if __name__ == '__main__':
    main()
